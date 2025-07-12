module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    parameter COPY = 1'b0;
    parameter INVERT = 1'b1;
    
    reg state;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= COPY;
        end else begin
            case (state)
                COPY: state <= x ? INVERT : COPY;
                INVERT: state <= INVERT;
            endcase
        end
    end

    // Output logic
    always @(*) begin
        case (state)
            COPY: z = x;
            INVERT: z = ~x;
        endcase
    end

endmodule