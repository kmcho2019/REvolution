module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State definitions with descriptive names
    localparam COPY = 1'b0;
    localparam INVERT = 1'b1;
    
    reg state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= COPY;
        end else begin
            case (state)
                COPY: begin
                    if (x) state <= INVERT;
                end
                INVERT: begin
                    // State maintained implicitly
                end
                default: begin
                    state <= COPY;
                end
            endcase
        end
    end

    // Output logic (combinational)
    always @(*) begin
        case (state)
            COPY:    z = x;
            INVERT:  z = ~x;
            default: z = x;
        endcase
    end

endmodule