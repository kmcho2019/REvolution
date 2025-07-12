module TopModule (
  input clk,
  input load,
  input ena,
  input [1:0] amount,
  input [63:0] data,
  output [63:0] q
);

// Define the number of segments
localparam NUM_SEGMENTS = 8;

// Define the width of each segment
localparam SEGMENT_WIDTH = 8;

// Define the total width of the data
localparam DATA_WIDTH = NUM_SEGMENTS * SEGMENT_WIDTH;

// Define the width of the shift amount
localparam SHIFT_AMOUNT_WIDTH = 2;

// Define the control signals for each segment
wire [NUM_SEGMENTS-1:0] shift_left;
wire [NUM_SEGMENTS-1:0] shift_right;
wire [NUM_SEGMENTS-1:0] load_segment;

// Define the data for each segment
reg [SEGMENT_WIDTH-1:0] segment_data [NUM_SEGMENTS-1:0];

// Define the output for each segment
wire [SEGMENT_WIDTH-1:0] segment_output [NUM_SEGMENTS-1:0];

// Control unit to determine shift operation
always @(*) begin
  for (int i = 0; i < NUM_SEGMENTS; i++) begin
    if (amount == 2'b00) begin
      shift_left[i] = 1'b1;
      shift_right[i] = 1'b0;
    end else if (amount == 2'b01) begin
      shift_left[i] = 1'b1;
      shift_right[i] = 1'b0;
    end else if (amount == 2'b10) begin
      shift_left[i] = 1'b0;
      shift_right[i] = 1'b1;
    end else if (amount == 2'b11) begin
      shift_left[i] = 1'b0;
      shift_right[i] = 1'b1;
    end
  end
end

// Load data into each segment
always @(posedge clk) begin
  if (load) begin
    for (int i = 0; i < NUM_SEGMENTS; i++) begin
      segment_data[i] <= data[(i*SEGMENT_WIDTH + SEGMENT_WIDTH - 1):(i*SEGMENT_WIDTH)];
    end
  end
end

// Shift each segment
for (genvar i = 0; i < NUM_SEGMENTS; i++) begin
  barrel_shifter #(.WIDTH(SEGMENT_WIDTH)) barrel_shifter_inst (
   .data(segment_data[i]),
   .shift_amount(amount),
   .shift_left(shift_left[i]),
   .shift_right(shift_right[i]),
   .output(segment_output[i])
  );
end

// Combine the output of each segment
assign q = {segment_output[NUM_SEGMENTS-1], segment_output[NUM_SEGMENTS-2], segment_output[NUM_SEGMENTS-3], segment_output[NUM_SEGMENTS-4],
            segment_output[NUM_SEGMENTS-5], segment_output[NUM_SEGMENTS-6], segment_output[NUM_SEGMENTS-7], segment_output[0]};

endmodule

module barrel_shifter #(
  parameter WIDTH = 8
) (
  input [WIDTH-1:0] data,
  input [1:0] shift_amount,
  input shift_left,
  input shift_right,
  output [WIDTH-1:0] output
);

// Define the shifted data
wire [WIDTH-1:0] shifted_data;

// Shift left by 1 bit
assign shifted_data = (shift_amount == 2'b00 && shift_left)? {data[WIDTH-2:0], 1'b0} :
                     (shift_amount == 2'b01 && shift_left)? {data[WIDTH-9:0], 8'b0} :
                     (shift_amount == 2'b10 && shift_right)? {data[WIDTH-1], data[WIDTH-1:1]} :
                     (shift_amount == 2'b11 && shift_right)? {{8{data[WIDTH-1]}}, data[WIDTH-1:8]} :
                     data;

assign output = shifted_data;

endmodule