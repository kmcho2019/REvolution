module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    reg state;  // 0=OFF, 1=ON
    reg [1:0] prev_inputs;
    wire inputs_changed = (prev_inputs != {j,k});
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
            prev_inputs <= 2'b00;
        end else if (inputs_changed) begin
            prev_inputs <= {j,k};
            if (~state & j) state <= 1'b1;  // OFF->ON when j=1
            else if (state & k) state <= 1'b0;  // ON->OFF when k=1
        end
    end
    
    assign out = state;
endmodule