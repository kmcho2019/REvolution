module fixed_point_adder #(
    parameter Q = 8, // Number of fractional bits
    parameter N = 16 // Total number of bits
)(
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c,
    input clk, // Clock signal
    input rst_n // Active-low reset signal
);

// Split inputs into integer and fractional parts
wire [N-Q-1:0] int_a = a[N-1:N-Q];
wire [Q-1:0] frac_a = a[N-Q-1:0];
wire [N-Q-1:0] int_b = b[N-1:N-Q];
wire [Q-1:0] frac_b = b[N-Q-1:0];

// Parallel integer adder
wire [N-Q:0] int_sum;
assign int_sum = {1'b0} + int_a + int_b;

// Pipelined fractional accumulator
reg [Q:0] frac_acc;
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        frac_acc <= {Q+1{1'b0}};
    end else begin
        frac_acc <= frac_acc + {1'b0} + frac_a + frac_b;
    end
end

// Dynamic saturation mechanism
wire overflow;
assign overflow = (int_sum[N-Q] || (frac_acc[Q] && ~int_sum[N-Q]));

// Clock-gating for power reduction
wire clk_enable;
assign clk_enable = (a !== {N{1'b0}} || b !== {N{1'b0}});

// Conditional clock enable
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        c <= {N{1'b0}};
    end else if (clk_enable) begin
        if (overflow) begin
            c <= {N{1'b1}};
        end else begin
            c <= {int_sum[N-Q-1:0], frac_acc[Q-1:0]};
        end
    end
end

endmodule