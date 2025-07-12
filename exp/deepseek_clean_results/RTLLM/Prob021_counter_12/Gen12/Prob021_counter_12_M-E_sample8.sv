module counter_12 (
    input wire rst_n,          // Active low reset
    input wire clk,            // Clock signal
    input wire valid_count,    // Enable counting when high
    output reg [3:0] out       // 4-bit counter output
);

// One-hot encoded state register (12 states)
reg [11:0] state;

// Next state and output logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= 12'b0000_0000_0001; // State 0
    end else if (valid_count) begin
        case (state)
            12'b0000_0000_0001: state <= 12'b0000_0000_0010; // 0->1
            12'b0000_0000_0010: state <= 12'b0000_0000_0100; // 1->2
            12'b0000_0000_0100: state <= 12'b0000_0000_1000; // 2->3
            12'b0000_0000_1000: state <= 12'b0000_0001_0000; // 3->4
            12'b0000_0001_0000: state <= 12'b0000_0010_0000; // 4->5
            12'b0000_0010_0000: state <= 12'b0000_0100_0000; // 5->6
            12'b0000_0100_0000: state <= 12'b0000_1000_0000; // 6->7
            12'b0000_1000_0000: state <= 12'b0001_0000_0000; // 7->8
            12'b0001_0000_0000: state <= 12'b0010_0000_0000; // 8->9
            12'b0010_0000_0000: state <= 12'b0100_0000_0000; // 9->10
            12'b0100_0000_0000: state <= 12'b1000_0000_0000; // 10->11
            12'b1000_0000_0000: state <= 12'b0000_0000_0001; // 11->0
            default: state <= 12'b0000_0000_0001; // Fault recovery
        endcase
    end
end

// Output encoding (priority encoder)
always @(*) begin
    case (state)
        12'b0000_0000_0001: out = 4'd0;
        12'b0000_0000_0010: out = 4'd1;
        12'b0000_0000_0100: out = 4'd2;
        12'b0000_0000_1000: out = 4'd3;
        12'b0000_0001_0000: out = 4'd4;
        12'b0000_0010_0000: out = 4'd5;
        12'b0000_0100_0000: out = 4'd6;
        12'b0000_1000_0000: out = 4'd7;
        12'b0001_0000_0000: out = 4'd8;
        12'b0010_0000_0000: out = 4'd9;
        12'b0100_0000_0000: out = 4'd10;
        12'b1000_0000_0000: out = 4'd11;
        default: out = 4'd0;
    endcase
end

endmodule