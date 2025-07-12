module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [3:0] shift_reg;
    wire [3:0] next_state;
    
    // Circular shift with external input
    assign next_state = {shift_reg[2:0], in};
    
    always @(posedge clk) begin
        if (!resetn) begin
            shift_reg <= 4'b0;
        end else begin
            shift_reg <= next_state;
        end
    end
    
    assign out = shift_reg[3];

endmodule