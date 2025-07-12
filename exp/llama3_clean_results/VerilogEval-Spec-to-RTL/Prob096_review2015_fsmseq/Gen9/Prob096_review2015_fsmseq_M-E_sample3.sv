module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define the shift register width
parameter WIDTH = 4;

// Define the shift registers
reg [WIDTH-1:0] shift_registers [0:WIDTH-1];

// Combinational logic to update the shift registers
always_comb begin
    for (int i = 0; i < WIDTH; i++) begin
        if (i == 0) begin
            shift_registers[i] = {data, 3'b000};
        end else begin
            shift_registers[i] = {shift_registers[i-1][2:0], data};
        end
    end
end

// Combinational logic to detect the sequence
reg detected;
always_comb begin
    detected = 1'b0;
    for (int i = 0; i < WIDTH; i++) begin
        if (shift_registers[i] == 4'b1101) begin
            detected = 1'b1;
        end
    end
end

// Sequential logic to update the start_shifting signal
always @(posedge clk) begin
    if (reset) begin
        start_shifting <= 1'b0;
    end else if (detected) begin
        start_shifting <= 1'b1;
    end
end

endmodule