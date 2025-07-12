module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    // One-hot state encoding
    localparam IDLE = 4'b0001;
    localparam LOAD = 4'b0010;
    localparam CALC = 4'b0100;
    localparam DONE = 4'b1000;

    reg [3:0] state, next_state;
    reg [4:0] count;  // Counts 0-16 (5 bits)
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] acc;
    reg [31:0] shifted_breg;

    // State transition logic (combinational)
    always @(*) begin
        case (state)
            IDLE: next_state = start ? LOAD : IDLE;
            LOAD: next_state = CALC;
            CALC: next_state = (count == 16) ? DONE : CALC;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // State register (sequential)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Datapath control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'b0;
            breg <= 16'b0;
            acc <= 32'b0;
            shifted_breg <= 32'b0;
            count <= 5'b0;
        end else begin
            case (state)
                IDLE: begin
                    areg <= 16'b0;
                    breg <= 16'b0;
                    acc <= 32'b0;
                    shifted_breg <= 32'b0;
                    count <= 5'b0;
                end
                LOAD: begin
                    areg <= ain;
                    breg <= bin;
                    acc <= 32'b0;
                    shifted_breg <= {16'b0, bin};
                    count <= 5'b0;
                end
                CALC: begin
                    if (count < 16) begin
                        if (areg[count]) begin
                            acc <= acc + shifted_breg;
                        end
                        shifted_breg <= shifted_breg << 1;
                    end
                    count <= count + 1;
                end
                DONE: begin
                    // Maintain current values
                end
            endcase
        end
    end

    // Output assignments
    assign yout = acc;
    assign done = (state == DONE);

endmodule