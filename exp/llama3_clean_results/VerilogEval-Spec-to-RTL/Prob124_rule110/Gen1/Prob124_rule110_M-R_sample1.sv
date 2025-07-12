module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
assign q = current_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= {next_state[511:0]};
    end
end

wire [511:0] next_state;

generate
    for (genvar i = 0; i < 512; i++) begin
        reg left, center, right;
        if (i == 0) begin
            assign left = 0;
        end else begin
            assign left = current_state[i-1];
        end
        assign center = current_state[i];
        if (i == 511) begin
            assign right = 0;
        end else begin
            assign right = current_state[i+1];
        end

        assign next_state[i] = 
            (left && center && right)? 0 :
            (left && center &&!right)? 1 :
            (left &&!center && right)? 1 :
            (left &&!center &&!right)? 0 :
            (!left && center && right)? 1 :
            (!left && center &&!right)? 1 :
            (!left &&!center && right)? 1 :
            (!left &&!center &&!right)? 0 : 0;
    end
endgenerate

endmodule