`define STATE_A 6'b000001
`define STATE_B 6'b000010
`define STATE_C 6'b000100
`define STATE_D 6'b001000
`define STATE_E 6'b010000
`define STATE_F 6'b100000

module TopModule(
  input  clk,
  input  reset,
  input  w,
  output z
);

reg [5:0] current_state;
reg [5:0] next_state;

always @(posedge clk or posedge reset) begin
  if(reset) begin
    current_state <= `STATE_A;
  end else begin
    current_state <= next_state;
  end
end

always @(*) begin
  case(current_state)
    `STATE_A: begin
      if(w) begin
        next_state = `STATE_A;
        z = 0;
      end else begin
        next_state = `STATE_B;
        z = 0;
      end
    end
    `STATE_B: begin
      if(w) begin
        next_state = `STATE_D;
        z = 0;
      end else begin
        next_state = `STATE_C;
        z = 0;
      end
    end
    `STATE_C: begin
      if(w) begin
        next_state = `STATE_D;
        z = 0;
      end else begin
        next_state = `STATE_E;
        z = 0;
      end
    end
    `STATE_D: begin
      if(w) begin
        next_state = `STATE_A;
        z = 0;
      end else begin
        next_state = `STATE_F;
        z = 0;
      end
    end
    `STATE_E: begin
      if(w) begin
        next_state = `STATE_D;
        z = 0;
      end else begin
        next_state = `STATE_E;
        z = 1;
      end
    end
    `STATE_F: begin
      if(w) begin
        next_state = `STATE_D;
        z = 1;
      end else begin
        next_state = `STATE_C;
        z = 1;
      end
    end
  endcase
end

endmodule