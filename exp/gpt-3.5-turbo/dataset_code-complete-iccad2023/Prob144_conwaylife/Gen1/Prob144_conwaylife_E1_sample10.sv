module Cell (
  input [255:0] q,
  input [7:0] r, c,
  output reg next_state
);

reg [2:0] num_neighbors;
reg [2:0] count;

always @*
begin
  count = q[{r+1, c+1}] + q[{r+1, c}] + q[{r+1, c-1}] +
          q[{r, c+1}] + q[{r, c-1}] +
          q[{r-1, c+1}] + q[{r-1, c}] + q[{r-1, c-1}];

  case (count)
    0, 1: num_neighbors = 3'b000;
    2: num_neighbors = 3'b010;
    3: num_neighbors = 3'b011;
    default: num_neighbors = 3'b000;
  endcase
  
  next_state = (count == 2 || count == 3) ? 1'b1 : 1'b0;
end

endmodule

module TopModule (
  input clk,
  input load,
  input [255:0] data,
  output reg [255:0] q
);

reg [255:0] next_q;

integer i, j;
wire [255:0] cell_states [0:255];

generate
  for (i = 0; i < 16; i = i + 1) begin
    for (j = 0; j < 16; j = j + 1) begin
      Cell cell_inst (
        .q(q),
        .r(i),
        .c(j),
        .next_state(cell_states[i*16 + j])
      );
    end
  end
endgenerate

always @(posedge clk)
begin
  if (load)
    q <= data;
  else
  begin
    for (i = 0; i < 16; i = i + 1)
      for (j = 0; j < 16; j = j + 1)
        next_q[i*16 + j] <= cell_states[i*16 + j];
    
    q <= next_q;
  end
end

endmodule