module accu (
    input clk,
    input rst_n,
    input [7:0] data_in,
    input valid_in,
    output reg valid_out,
    output reg [9:0] data_out
);

reg [3:0] state;  // One-hot encoded state (0001, 0010, 0100, 1000)
reg [9:0] accumulator;
reg [9:0] adder_out;

// State transition and accumulator update
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 4'b0001;
        accumulator <= 10'b0;
        adder_out <= 10'b0;
    end
    else if (valid_in) begin
        // Registered adder to break critical path
        adder_out <= accumulator + data_in;
        
        // State transition
        case (state)
            4'b0001: state <= 4'b0010;
            4'b0010: state <= 4'b0100;
            4'b0100: state <= 4'b1000;
            4'b1000: state <= 4'b0001;
            default: state <= 4'b0001;
        endcase
        
        // Accumulator update
        if (state == 4'b1000) begin
            accumulator <= 10'b0;
        end else begin
            accumulator <= adder_out;
        end
    end
end

// Output generation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        valid_out <= 1'b0;
        data_out <= 10'b0;
    end
    else begin
        valid_out <= (state == 4'b1000) & valid_in;
        if (state == 4'b1000) begin
            data_out <= adder_out;
        end
    end
end

endmodule