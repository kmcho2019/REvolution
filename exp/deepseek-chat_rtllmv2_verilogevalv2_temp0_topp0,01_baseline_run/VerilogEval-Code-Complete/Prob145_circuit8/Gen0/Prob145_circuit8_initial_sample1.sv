module TopModule (
  input clock,
  input a,
  output reg p,
  output reg q
);

  reg p_next;
  reg q_next;
  reg a_prev;

  always @(posedge clock) begin
    a_prev <= a;
  end

  always @(*) begin
    // p follows a only when q is 0
    p_next = q ? 1'b0 : a;
    
    // q sets when p was high for full cycle, resets when a is high on falling edge
    if (~clock && a) begin
      q_next = 1'b0;
    end
    else if (p && a_prev) begin
      q_next = 1'b1;
    end
    else begin
      q_next = q;
    end
  end

  always @(posedge clock) begin
    p <= p_next;
    q <= q_next;
  end

endmodule