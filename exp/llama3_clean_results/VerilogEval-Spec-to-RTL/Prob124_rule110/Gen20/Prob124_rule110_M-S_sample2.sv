module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

integer i;
always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        for (i = 0; i < 512; i++) begin
            next_state[i] = 
                (i > 0 && i < 511) ? 
                    (current_state[i-1] && current_state[i] && current_state[i+1]) ? 1'b0 :
                    (current_state[i-1] && current_state[i] && ~current_state[i+1]) ? 1'b1 :
                    (current_state[i-1] && ~current_state[i] && current_state[i+1]) ? 1'b1 :
                    (current_state[i-1] && ~current_state[i] && ~current_state[i+1]) ? 1'b0 :
                    (~current_state[i-1] && current_state[i] && current_state[i+1]) ? 1'b1 :
                    (~current_state[i-1] && current_state[i] && ~current_state[i+1]) ? 1'b1 :
                    (~current_state[i-1] && ~current_state[i] && current_state[i+1]) ? 1'b1 :
                    1'b0 :
                (i == 0) ? 
                    (current_state[i] && ~current_state[i+1]) ? 1'b1 :
                    (~current_state[i] && current_state[i+1]) ? 1'b1 :
                    (~current_state[i] && ~current_state[i+1]) ? 1'b0 :
                    1'b0 :
                (i == 511) ? 
                    (current_state[i-1] && current_state[i]) ? 1'b0 :
                    (current_state[i-1] && ~current_state[i]) ? 1'b0 :
                    (~current_state[i-1] && current_state[i]) ? 1'b1 :
                    1'b0;
        end
        current_state <= next_state;
    end
end

assign q = current_state;

endmodule