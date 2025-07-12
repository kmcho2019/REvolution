module signal_generator (
    input clk,
    input rst_n,
    output [4:0] wave
);

parameter MAX_VAL = 5'd31;
reg [5:0] counter; // 6-bit counter for automatic direction change

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        counter <= 6'b0;
    end else begin
        counter <= counter + 1;
    end
end

// Triangle wave generation
assign wave = counter[5] ? (MAX_VAL - counter[4:0]) : counter[4:0];

endmodule