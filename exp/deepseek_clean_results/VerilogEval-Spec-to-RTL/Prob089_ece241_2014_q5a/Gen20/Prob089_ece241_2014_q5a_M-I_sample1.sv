module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // State definitions with descriptive names
    localparam COPY = 1'b0;
    localparam INVERT = 1'b1;
    
    reg state;

    // Output is now combinational
    assign z = (state == COPY) ? x : ~x;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= COPY;
        end else begin
            case (state)
                COPY: if (x) state <= INVERT;
                INVERT: state <= INVERT; // Stay in INVERT state
            endcase
        end
    end

endmodule