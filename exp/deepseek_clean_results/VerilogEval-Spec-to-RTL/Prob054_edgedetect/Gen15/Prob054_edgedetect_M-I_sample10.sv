module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    // Packed 16-bit history register (2 bits per input)
    reg [15:0] history;
    reg [7:0] prev_in;
    
    wire [7:0] input_changed = prev_in ^ in;
    
    always @(posedge clk) begin
        prev_in <= in;
        
        // Only update history bits when their inputs change
        if (|input_changed) begin
            history <= {history[13:0], in};
        end
        
        // Positive edge detection (01 pattern in history)
        pedge <= {history[15:14] == 2'b01,
                  history[13:12] == 2'b01,
                  history[11:10] == 2'b01,
                  history[9:8]   == 2'b01,
                  history[7:6]   == 2'b01,
                  history[5:4]   == 2'b01,
                  history[3:2]   == 2'b01,
                  history[1:0]   == 2'b01};
    end

endmodule