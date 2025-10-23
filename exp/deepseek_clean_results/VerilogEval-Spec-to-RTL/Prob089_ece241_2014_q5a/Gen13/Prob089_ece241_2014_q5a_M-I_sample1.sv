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
    wire output_enable = (state == COPY) || (state == INVERT && ~x);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= COPY;
            z <= 1'b0;
        end else begin
            case (state)
                COPY: begin
                    z <= x;
                    if (x) state <= INVERT;
                end
                INVERT: begin
                    if (output_enable) z <= ~x;
                end
            endcase
        end
    end

endmodule