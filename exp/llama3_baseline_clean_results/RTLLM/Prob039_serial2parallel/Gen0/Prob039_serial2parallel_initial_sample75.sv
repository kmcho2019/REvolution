module serial2parallel(
    input         clk,        // Clock signal
    input         rst_n,      // Reset signal (active low)
    input         din_serial, // Serial input data
    input         din_valid,  // Validity signal for input data
    output [7:0]  dout_parallel, // Parallel output data (8 bits wide)
    output        dout_valid   // Validity signal for the output data
);

reg [2:0] cnt; // 3-bit counter to keep track of the number of serial input data bits received
reg [7:0] dout_parallel_reg; // Register for parallel output data
reg       dout_valid_reg;    // Register for output validity signal

// Initialize the output registers
initial begin
    cnt <= 3'b000;
    dout_parallel_reg <= 8'b00000000;
    dout_valid_reg <= 1'b0;
end

// Main logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        cnt <= 3'b000;
        dout_parallel_reg <= 8'b00000000;
        dout_valid_reg <= 1'b0;
    end else if (din_valid) begin // When input data is valid
        if (cnt == 3'b111) begin // When 8 serial data bits have been received
            cnt <= 3'b000; // Reset the counter
            dout_parallel_reg <= dout_parallel_reg; // Output the parallel data
            dout_valid_reg <= 1'b1; // Set the output validity signal to 1
        end else begin
            case (cnt)
                3'b000: dout_parallel_reg <= {din_serial, 7'b0000000}; // MSB
                3'b001: dout_parallel_reg <= {dout_parallel_reg[7:1], din_serial, 6'b000000};
                3'b010: dout_parallel_reg <= {dout_parallel_reg[7:2], din_serial, 5'b00000};
                3'b011: dout_parallel_reg <= {dout_parallel_reg[7:3], din_serial, 4'b0000};
                3'b100: dout_parallel_reg <= {dout_parallel_reg[7:4], din_serial, 3'b000};
                3'b101: dout_parallel_reg <= {dout_parallel_reg[7:5], din_serial, 2'b00};
                3'b110: dout_parallel_reg <= {dout_parallel_reg[7:6], din_serial, 1'b0};
                3'b111: dout_parallel_reg <= {dout_parallel_reg[7:7], din_serial};
            endcase
            cnt <= cnt + 1'b1; // Increment the counter
            dout_valid_reg <= 1'b0; // Reset the output validity signal
        end
    end else begin
        cnt <= cnt;
        dout_parallel_reg <= dout_parallel_reg;
        if (dout_valid_reg) begin
            dout_valid_reg <= 1'b0; // Reset the output validity signal after one clock cycle
        end else begin
            dout_valid_reg <= 1'b0;
        end
    end
end

// Output assignments
assign dout_parallel = dout_parallel_reg;
assign dout_valid = dout_valid_reg;

endmodule