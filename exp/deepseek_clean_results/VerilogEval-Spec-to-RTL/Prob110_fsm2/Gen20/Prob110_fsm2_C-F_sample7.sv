module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);

    parameter OFF = 1'b0;
    parameter ON  = 1'b1;
    
    reg state;  // Binary state encoding (0=OFF, 1=ON)

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;  // Asynchronous reset to OFF state
        end else begin
            case (state)
                OFF: state <= j;    // OFF -> ON if j=1, else stay OFF
                ON:  state <= ~k;   // ON -> OFF if k=1, else stay ON
            endcase
        end
    end

    assign out = state;  // Direct output from state (Moore machine)

endmodule