module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

integer i;

always @(*) begin
    for (i = 0; i < 512; i++) begin
        if (i == 0) begin
            // Left neighbor is 0 for the first cell
            next_state[i] = (current_state[i + 1] == 1 && current_state[i] == 1 && current_state[i] == 1)? 0 :
                            (current_state[i + 1] == 1 && current_state[i] == 1 && current_state[i] == 0)? 1 :
                            (current_state[i + 1] == 1 && current_state[i] == 0 && current_state[i] == 1)? 1 :
                            (current_state[i + 1] == 1 && current_state[i] == 0 && current_state[i] == 0)? 0 :
                            (current_state[i + 1] == 0 && current_state[i] == 1 && current_state[i] == 1)? 1 :
                            (current_state[i + 1] == 0 && current_state[i] == 1 && current_state[i] == 0)? 1 :
                            (current_state[i + 1] == 0 && current_state[i] == 0 && current_state[i] == 1)? 1 :
                            (current_state[i + 1] == 0 && current_state[i] == 0 && current_state[i] == 0)? 0 : 0;
        end else if (i == 511) begin
            // Right neighbor is 0 for the last cell
            next_state[i] = (current_state[i - 1] == 1 && current_state[i] == 1 && 0 == 1)? 0 :
                            (current_state[i - 1] == 1 && current_state[i] == 1 && 0 == 0)? 1 :
                            (current_state[i - 1] == 1 && current_state[i] == 0 && 0 == 1)? 1 :
                            (current_state[i - 1] == 1 && current_state[i] == 0 && 0 == 0)? 0 :
                            (current_state[i - 1] == 0 && current_state[i] == 1 && 0 == 1)? 1 :
                            (current_state[i - 1] == 0 && current_state[i] == 1 && 0 == 0)? 1 :
                            (current_state[i - 1] == 0 && current_state[i] == 0 && 0 == 1)? 1 :
                            (current_state[i - 1] == 0 && current_state[i] == 0 && 0 == 0)? 0 : 0;
        end else begin
            next_state[i] = (current_state[i - 1] == 1 && current_state[i] == 1 && current_state[i + 1] == 1)? 0 :
                            (current_state[i - 1] == 1 && current_state[i] == 1 && current_state[i + 1] == 0)? 1 :
                            (current_state[i - 1] == 1 && current_state[i] == 0 && current_state[i + 1] == 1)? 1 :
                            (current_state[i - 1] == 1 && current_state[i] == 0 && current_state[i + 1] == 0)? 0 :
                            (current_state[i - 1] == 0 && current_state[i] == 1 && current_state[i + 1] == 1)? 1 :
                            (current_state[i - 1] == 0 && current_state[i] == 1 && current_state[i + 1] == 0)? 1 :
                            (current_state[i - 1] == 0 && current_state[i] == 0 && current_state[i + 1] == 1)? 1 :
                            (current_state[i - 1] == 0 && current_state[i] == 0 && current_state[i + 1] == 0)? 0 : 0;
        end
    end
end

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

assign q = current_state;

endmodule