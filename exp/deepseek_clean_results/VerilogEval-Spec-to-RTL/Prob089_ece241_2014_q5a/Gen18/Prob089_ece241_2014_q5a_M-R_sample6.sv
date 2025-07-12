module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // State definitions
    localparam COPY = 1'b0;
    localparam INVERT = 1'b1;
    
    reg state;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= COPY;
        end else begin
            case (state)
                COPY: if (x) state <= INVERT;
                INVERT: state <= INVERT; // Stay in INVERT once entered
            endcase
        end
    end

    // Combinational output logic
    assign z = (state == COPY) ? x : ~x;

endmodule