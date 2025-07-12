module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    // State definitions
    localparam IDLE = 1'b0;
    localparam SAW_ONE = 1'b1;

    // State registers for each bit
    reg [31:0] state;

    // Output register
    reg [31:0] out_reg;

    // Next state and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= 32'b0;      // All bits in IDLE state
            out_reg <= 32'b0;
        end else begin
            for (integer i = 0; i < 32; i = i + 1) begin
                case (state[i])
                    IDLE: begin
                        if (in[i]) begin
                            state[i] <= SAW_ONE;
                        end
                    end
                    SAW_ONE: begin
                        if (!in[i]) begin
                            state[i] <= IDLE;
                            out_reg[i] <= 1'b1;
                        end
                    end
                endcase
            end
        end
    end

    assign out = out_reg;

endmodule