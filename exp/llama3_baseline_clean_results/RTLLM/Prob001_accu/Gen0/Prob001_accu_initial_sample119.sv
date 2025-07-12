module accu(
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output valid_out,
    output [9:0] data_out
);

reg [1:0] count; // Counter for valid inputs
reg [9:0] sum; // Accumulated sum
reg valid_out_reg; // Registered valid_out signal
reg [9:0] data_out_reg; // Registered data_out signal

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        count <= 2'd0; // Reset counter
        sum <= 10'd0; // Reset accumulated sum
        valid_out_reg <= 1'b0; // Reset valid_out signal
    end else if (valid_in) begin
        case (count)
            2'd0: begin
                sum <= {2'd0, data_in}; // Initialize sum with first valid input
                count <= count + 1'b1; // Increment counter
            end
            2'd1: begin
                sum <= sum + {2'd0, data_in}; // Accumulate second valid input
                count <= count + 1'b1; // Increment counter
            end
            2'd2: begin
                sum <= sum + {2'd0, data_in}; // Accumulate third valid input
                count <= count + 1'b1; // Increment counter
            end
            2'd3: begin
                sum <= sum + {2'd0, data_in}; // Accumulate fourth valid input
                valid_out_reg <= 1'b1; // Set valid_out signal for next cycle
                data_out_reg <= sum; // Prepare data_out for next cycle
                count <= 2'd0; // Reset counter for next set of inputs
            end
        endcase
    end else begin
        valid_out_reg <= 1'b0; // Reset valid_out signal if no valid input
    end
end

assign valid_out = valid_out_reg;
assign data_out = data_out_reg;

endmodule