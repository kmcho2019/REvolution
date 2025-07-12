module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State definitions
    localparam COPY = 1'b0;
    localparam INVERT = 1'b1;
    
    reg state;
    wire clk_gated = (state == INVERT) ? 1'b0 : clk;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= COPY;
        end else begin
            case (state)
                COPY: begin
                    if (x) state <= INVERT;
                end
                // INVERT state remains implicitly
            endcase
        end
    end

    always @(posedge clk_gated or posedge areset) begin
        if (areset) begin
            z <= 1'b0;
        end else begin
            case (state)
                COPY: z <= x;
                INVERT: z <= ~x;
            endcase
        end
    end

endmodule