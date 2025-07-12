module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // State definitions
    parameter COPY = 1'b0;
    parameter INVERT = 1'b1;
    
    reg state;

    // Combinational output logic
    assign z = (state == COPY) ? x : ~x;

    // Sequential state transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= COPY;
        end else begin
            case (state)
                COPY: if (x) state <= INVERT;
                INVERT: state <= INVERT; // Maintain state
            endcase
        end
    end

endmodule