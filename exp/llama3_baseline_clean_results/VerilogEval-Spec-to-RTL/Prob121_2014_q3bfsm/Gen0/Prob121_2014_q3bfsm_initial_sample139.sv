module TopModule (
    input  logic clk,
    input  logic reset,
    input  logic x,
    output logic z
);

    logic [2:0] y; // Current state

    always_ff @(posedge clk) begin
        if (reset) begin // Synchronous active high reset
            y <= 3'b000;
        end else begin
            case (y)
                3'b000: y <= x ? 3'b001 : 3'b000;
                3'b001: y <= x ? 3'b100 : 3'b001;
                3'b010: y <= x ? 3'b001 : 3'b010;
                3'b011: y <= x ? 3'b010 : 3'b001;
                3'b100: y <= x ? 3'b100 : 3'b011;
                default: y <= 3'b000; // Default to state 000 for any other state
            endcase
        end
    end

    always_comb begin
        case (y)
            3'b000, 3'b001, 3'b010: z = 1'b0;
            3'b011, 3'b100: z = 1'b1;
            default: z = 1'b0; // Default output to 0 for any other state
        endcase
    end

endmodule