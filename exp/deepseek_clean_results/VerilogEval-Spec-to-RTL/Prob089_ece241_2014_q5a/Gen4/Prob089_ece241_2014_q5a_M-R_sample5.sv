module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    localparam COPY = 1'b0;
    localparam INVERT = 1'b1;
    
    reg state;
    
    // Combinational output logic
    assign z = (state == INVERT) ? ~x : x;
    
    // Sequential state transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= COPY;
        end else begin
            case (state)
                COPY:    if (x) state <= INVERT;
                INVERT:  state <= INVERT;
            endcase
        end
    end

endmodule