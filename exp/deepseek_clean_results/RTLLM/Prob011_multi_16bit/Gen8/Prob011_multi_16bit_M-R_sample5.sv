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
    reg [3:0] bit_cnt;      // Now only needs 4 bits (0-15)
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] acc;

    // Pre-compute all possible shifted versions
    wire [31:0] shifted [0:15];
    generate
        genvar i;
        for (i=0; i<16; i=i+1) begin : shift_gen
            assign shifted[i] = {16'b0, breg} << i;
        end
    endgenerate

    // State transition logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            bit_cnt <= 4'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            acc <= 32'd0;
        end
        else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    bit_cnt <= 4'd0;
                    acc <= 32'd0;
                end
                LOAD: begin
                    areg <= ain;
                    breg <= bin;
                    bit_cnt <= 4'd0;
                end
                CALC: begin
                    if (areg[bit_cnt])
                        acc <= acc + shifted[bit_cnt];
                    bit_cnt <= bit_cnt + 1;
                end
                DONE: begin
                    // Maintain state until next start
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = start ? LOAD : IDLE;
            LOAD: next_state = CALC;
            CALC: next_state = (bit_cnt == 4'd15) ? DONE : CALC;
            DONE: next_state = start ? LOAD : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Output assignments
    assign yout = (state == DONE) ? acc : 32'd0;
    assign done = (state == DONE);

endmodule