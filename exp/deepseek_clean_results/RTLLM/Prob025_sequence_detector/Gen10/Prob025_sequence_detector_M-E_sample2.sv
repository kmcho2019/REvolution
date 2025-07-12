module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

// History registers (stores bits [n-1] and [n-2])
reg [1:0] history;

// Detection logic wires
wire first_half_match = (history == 2'b10);  // Matches "10" prefix
wire second_half_match = (history[0] & ~data_in); // Matches "0x" where x is 1
wire full_match = first_half_match & (data_in == 1'b1); // Complete "1001"

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        history <= 2'b0;
        sequence_detected <= 1'b0;
    end
    else begin
        // Update history register
        history <= {history[0], data_in};
        
        // Detection occurs when:
        // 1. Previous 3 bits were "100" (first_half_match)
        // 2. Current bit is "1"
        sequence_detected <= full_match;
    end
end

endmodule