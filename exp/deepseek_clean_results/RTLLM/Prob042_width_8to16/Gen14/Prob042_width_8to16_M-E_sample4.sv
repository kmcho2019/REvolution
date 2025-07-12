module width_8to16 (
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire [7:0] data_in,
    
    output reg valid_out,
    output reg [15:0] data_out
);

reg [1:0] data_counter;
reg [15:0] data_accumulator;

// Data accumulation logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_accumulator <= 16'b0;
    end else if (valid_in) begin
        // Shift new data into accumulator
        data_accumulator <= {data_accumulator[7:0], data_in};
    end
end

// Control logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_counter <= 2'b0;
        valid_out <= 1'b0;
    end else begin
        valid_out <= 1'b0;
        
        if (valid_in) begin
            if (data_counter == 2'b01) begin
                // When we have two bytes, output and reset
                data_out <= {data_accumulator[15:8], data_in};
                valid_out <= 1'b1;
                data_counter <= 2'b0;
            end else begin
                // Increment counter for first byte
                data_counter <= data_counter + 1'b1;
            end
        end
    end
end

endmodule