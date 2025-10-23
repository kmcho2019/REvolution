module TopModule(d, ena, q);
  input d;
  input ena;
  output reg q;

  always @(d or ena) begin
    if (ena) begin
      q = d; // Using blocking assignment for better synthesizability
    end else begin
      // No need for an else condition as q will hold its value when ena is low
    end
  end
endmodule