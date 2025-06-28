module TopModule (
  input clk,
  input reset,
  input in,
  output reg disc,
  output reg flag,
  output reg err
);

reg [2:0] counter;
reg [2:0] next_counter;
reg searching_flag, discard_flag;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    counter <= 3'b0;
    searching_flag <= 1'b0;
    discard_flag <= 1'b0;
    disc <= 1'b0;
    flag <= 1'b0;
    err <= 1'b0;
  end
  else begin
    counter <= next_counter;
    discard_flag <= (counter == 3'b110);
    searching_flag <= (counter != 3'b111);
    disc <= discard_flag;
    flag <= (counter == 3'b111 && !discard_flag);
    err <= (counter >= 4'b1110);
    
    // Update counter based on input
    case ({in, counter, searching_flag})
      {1, 3'bxxx, 1}: next_counter = counter + 1; // Increment counter
      {1, 3'bxxx, 0}: next_counter = 3'b001;      // Reset counter and increment
      {0, 3'bxxx, _}: next_counter = 3'b000;       // Reset counter
    endcase
  end
end

endmodule