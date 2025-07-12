module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state;
    
    // State definitions
    localparam COPY = 1'b0;
    localparam INVERT = 1'b1;
    
    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= COPY;
        end else begin
            case (state)
                COPY: if (x) state <= INVERT;
                INVERT: state <= INVERT;
            endcase
        end
    end
    
    // Output logic (combinational)
    assign z = (state == COPY) ? x : ~x;

endmodule