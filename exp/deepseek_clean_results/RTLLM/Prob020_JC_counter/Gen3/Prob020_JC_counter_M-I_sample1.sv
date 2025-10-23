module JC_counter (
    input clk,
    input rst_n,
    output reg [63:0] Q
);

reg [63:0] Q_next;
reg [5:0] transition_pos;
reg direction;  // 0: filling with 1s, 1: clearing with 0s

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
        transition_pos <= 6'd0;
        direction <= 0;
    end else begin
        if (direction == 0) begin
            // Filling phase
            if (transition_pos < 6'd63) begin
                Q <= {64{1'b1}} << (63 - transition_pos);
                transition_pos <= transition_pos + 1;
            end else begin
                Q <= {64{1'b1}};
                direction <= 1;
                transition_pos <= 6'd0;
            end
        end else begin
            // Clearing phase
            if (transition_pos < 6'd63) begin
                Q <= {64{1'b1}} >> (transition_pos + 1);
                transition_pos <= transition_pos + 1;
            end else begin
                Q <= 64'b0;
                direction <= 0;
                transition_pos <= 6'd0;
            end
        end
    end
end

endmodule