module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Extended inputs with size zeros at MSB
wire [2*size-1:0] a_ext = {{size{1'b0}}, mul_a};
wire [2*size-1:0] b_ext = {{size{1'b0}}, mul_b};

// Stage 1: Partial Products
reg [2*size-1:0] pp [0:size-1];
wire [2*size-1:0] pp_wire [0:size-1];

generate
    genvar i;
    for (i = 0; i < size; i = i + 1) begin : pp_gen
        assign pp_wire[i] = b_ext[i] ? (a_ext << i) : '0;
        
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) pp[i] <= '0;
            else pp[i] <= pp_wire[i];
        end
    end
endgenerate

// Stage 2: First Addition Level
reg [2*size-1:0] sum0, sum1;
wire [2*size-1:0] sum0_wire = pp[0] + pp[1];
wire [2*size-1:0] sum1_wire = pp[2] + pp[3];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum0 <= '0;
        sum1 <= '0;
    end else begin
        sum0 <= sum0_wire;
        sum1 <= sum1_wire;
    end
end

// Stage 3: Final Sum and Output
wire [2*size-1:0] final_sum = sum0 + sum1;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) mul_out <= '0;
    else mul_out <= final_sum;
end

endmodule