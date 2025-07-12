module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

reg [3:0] state;

// Priority encoder
wire [1:0] priority;
assign priority = (r[0])? 2'b00 :
                  (r[1])? 2'b01 :
                  (r[2])? 2'b10 :
                  2'b11;

// Next state logic
always @(posedge clk) begin
    if (~resetn) state <= 4'b0001;
    else begin
        case (state)
            4'b0001: // State A
                if (priority == 2'b00) state <= 4'b0010; // Request from device 0
                else if (priority == 2'b01) state <= 4'b0100; // Request from device 1
                else if (priority == 2'b10) state <= 4'b1000; // Request from device 2
                else state <= 4'b0001; // No requests
            4'b0010: // State B
                if (!r[0]) state <= 4'b0001; // Device 0 releases request
                else state <= 4'b0010; // Device 0 still requesting
            4'b0100: // State C
                if (!r[1]) state <= 4'b0001; // Device 1 releases request
                else state <= 4'b0100; // Device 1 still requesting
            4'b1000: // State D
                if (!r[2]) state <= 4'b0001; // Device 2 releases request
                else state <= 4'b1000; // Device 2 still requesting
            default: state <= 4'b0001; // Invalid state
        endcase
    end
end

// Output assignments
assign g[0] = (state == 4'b0010);
assign g[1] = (state == 4'b0100);
assign g[2] = (state == 4'b1000);

endmodule