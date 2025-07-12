module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    parameter COPY = 1'b0;
    parameter INVERT = 1'b1;
    
    reg state;
    
    // Output is combinational logic based on state
    assign z = (state == COPY) ? x : ~x;
    
    // State transitions are sequential
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