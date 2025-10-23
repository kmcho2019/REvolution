module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output reg  out
);

    reg A, B; // One-hot encoded states: A=1 means state A, B=1 means state B

    // Asynchronous reset and state register update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            A <= 1'b0;
            B <= 1'b1;  // Reset state to B
        end else begin
            // Next state logic
            case ({A, B})
                2'b01: // State B
                    if (in == 1'b0) begin
                        A <= 1'b1; B <= 1'b0; // B->A on 0
                    end else begin
                        A <= 1'b0; B <= 1'b1; // B->B on 1
                    end
                2'b10: // State A
                    if (in == 1'b0) begin
                        A <= 1'b0; B <= 1'b1; // A->B on 0
                    end else begin
                        A <= 1'b1; B <= 1'b0; // A->A on 1
                    end
                default: begin
                    // Invalid state: reset to B
                    A <= 1'b0;
                    B <= 1'b1;
                end
            endcase
        end
    end

    // Output: 1 when in state B, else 0 (Moore output)
    always @(*) begin
        out = B;
    end

endmodule