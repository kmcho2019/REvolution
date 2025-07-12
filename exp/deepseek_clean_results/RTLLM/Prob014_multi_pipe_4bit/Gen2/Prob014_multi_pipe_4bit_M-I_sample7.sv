module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extended versions of inputs
    wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};
    wire [2*size-1:0] ext_b = {{size{1'b0}}, mul_b};

    // Registered partial products
    reg [2*size-1:0] pp [size-1:0];
    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j = 0; j < size; j = j + 1) begin
                pp[j] <= {(2*size){1'b0}};
            end
        end else begin
            for (j = 0; j < size; j = j + 1) begin
                pp[j] <= ext_b[j] ? (ext_a << j) : {(2*size){1'b0}};
            end
        end
    end

    // Pipeline stage 1 registers
    reg [2*size-1:0] sum01, sum23;

    // Pipeline stage 2 register
    reg [2*size-1:0] sum_final;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            sum01 <= {(2*size){1'b0}};
            sum23 <= {(2*size){1'b0}};
            sum_final <= {(2*size){1'b0}};
            mul_out <= {(2*size){1'b0}};
        end else begin
            // Pipeline stage 1: parallel additions
            sum01 <= pp[0] + pp[1];
            sum23 <= pp[2] + pp[3];
            
            // Pipeline stage 2: final addition
            sum_final <= sum01 + sum23;
            
            // Output register
            mul_out <= sum_final;
        end
    end

endmodule