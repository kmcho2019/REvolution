module up_down_counter #(
    parameter WIDTH = 16,
    parameter SATURATE = 0  // 0 = wrap, 1 = saturate
) (
    input clk,
    input reset,
    input up_down,
    output reg [WIDTH-1:0] count
);

// Split into upper and lower bytes
wire [WIDTH/2-1:0] lower_count = count[WIDTH/2-1:0];
wire [WIDTH/2-1:0] upper_count = count[WIDTH-1:WIDTH/2];

// Next value pre-computation
wire [WIDTH/2:0] lower_next = up_down ? {1'b0, lower_count} + 1'b1 : 
                                       {1'b0, lower_count} - 1'b1;
wire lower_wrap = lower_next[WIDTH/2];
wire [WIDTH/2-1:0] lower_next_val = lower_next[WIDTH/2-1:0];

wire [WIDTH/2:0] upper_next = up_down ? {1'b0, upper_count} + lower_wrap : 
                                       {1'b0, upper_count} - lower_wrap;
wire upper_wrap = upper_next[WIDTH/2];
wire [WIDTH/2-1:0] upper_next_val = upper_next[WIDTH/2-1:0];

// Saturation logic
wire [WIDTH-1:0] next_count;
generate
    if (SATURATE) begin
        assign next_count = reset ? {WIDTH{1'b0}} :
                          (up_down && &count) ? count :  // Max reached
                          (!up_down && (count == 0)) ? count : // Min reached
                          {upper_next_val, lower_next_val};
    end else begin
        assign next_count = reset ? {WIDTH{1'b0}} : 
                          {upper_next_val, lower_next_val};
    end
endgenerate

// Sequential update with conditional clock gating
always @(posedge clk) begin
    if (reset) begin
        count <= {WIDTH{1'b0}};
    end else begin
        // Only update lower byte if no wrap occurs
        if (!lower_wrap) begin
            count[WIDTH/2-1:0] <= lower_next_val;
        end else begin
            count <= {upper_next_val, lower_next_val};
        end
    end
end

endmodule