module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam LOAD = 2'b01;
    localparam CALC = 2'b10;
    localparam DONE = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] count;
    reg [15:0] areg, breg;
    reg [31:0] acc;
    reg done_r;

    // Pre-compute all possible shifted versions
    wire [31:0] shifted_b [0:15];
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : shift_gen
            assign shifted_b[i] = {16'b0, breg} << i;
        end
    endgenerate

    // State machine sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 4'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            acc <= 32'd0;
            done_r <= 1'b0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    count <= 4'd0;
                    acc <= 32'd0;
                    done_r <= 1'b0;
                end
                LOAD: begin
                    areg <= ain;
                    breg <= bin;
                    count <= 4'd0;
                    acc <= 32'd0;
                end
                CALC: begin
                    if (areg[count]) begin
                        acc <= acc + shifted_b[count];
                    end
                    count <= count + 1;
                end
                DONE: begin
                    done_r <= 1'b1;
                end
            endcase
        end
    end

    // State machine combinational logic
    always @(*) begin
        case (state)
            IDLE: next_state = start ? LOAD : IDLE;
            LOAD: next_state = CALC;
            CALC: next_state = (count == 15) ? DONE : CALC;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output assignments
    assign yout = acc;
    assign done = done_r;

endmodule