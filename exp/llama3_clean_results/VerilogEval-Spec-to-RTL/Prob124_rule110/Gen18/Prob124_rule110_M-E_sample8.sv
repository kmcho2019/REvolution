module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

genvar i;
generate
    for (i = 0; i < 512; i++) begin
        wire left, center, right;
        
        assign left = (i == 0)? 1'b0 : current_state[i-1];
        assign center = current_state[i];
        assign right = (i == 511)? 1'b0 : current_state[i+1];
        
        // Apply Rule 110 logic using a lookup table approach
        always @(*) begin
            case ({left, center, right})
                3'b111: next_state[i] = 1'b0;
                3'b110: next_state[i] = 1'b1;
                3'b101: next_state[i] = 1'b1;
                3'b100: next_state[i] = 1'b0;
                3'b011: next_state[i] = 1'b1;
                3'b010: next_state[i] = 1'b1;
                3'b001: next_state[i] = 1'b1;
                3'b000: next_state[i] = 1'b0;
                default: next_state[i] = 1'bx;
            endcase
        end
    end
endgenerate

assign q = current_state;

endmodule