module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        next_state[0] = (current_state[0] && current_state[1]) ? 0 :
                         (current_state[0] && !current_state[1]) ? 1 :
                         (!current_state[0] && current_state[1]) ? 1 :
                         (!current_state[0] && !current_state[1]) ? 0 : 0;

        next_state[511] = (current_state[510] && current_state[511]) ? 1 :
                          (current_state[510] && !current_state[511]) ? 1 :
                          (!current_state[510] && current_state[511]) ? 1 :
                          (!current_state[510] && !current_state[511]) ? 0 : 0;

        for (int i = 1; i < 511; i++) begin
            next_state[i] = (current_state[i-1] && current_state[i] && current_state[i+1]) ? 0 :
                            (current_state[i-1] && current_state[i] && !current_state[i+1]) ? 1 :
                            (current_state[i-1] && !current_state[i] && current_state[i+1]) ? 1 :
                            (current_state[i-1] && !current_state[i] && !current_state[i+1]) ? 0 :
                            (!current_state[i-1] && current_state[i] && current_state[i+1]) ? 1 :
                            (!current_state[i-1] && current_state[i] && !current_state[i+1]) ? 1 :
                            (!current_state[i-1] && !current_state[i] && current_state[i+1]) ? 1 :
                            (!current_state[i-1] && !current_state[i] && !current_state[i+1]) ? 0 : 0;
        end

        current_state <= next_state;
    end
end

assign q = current_state;

endmodule