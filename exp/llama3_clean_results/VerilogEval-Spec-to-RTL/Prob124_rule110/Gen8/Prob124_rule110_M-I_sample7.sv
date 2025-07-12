module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] current_state;
reg [511:0] next_state;

function logic rule110(logic left, logic center, logic right);
    case ({left, center, right})
        3'b111: return 1'b0;
        3'b110: return 1'b1;
        3'b101: return 1'b1;
        3'b100: return 1'b0;
        3'b011: return 1'b1;
        3'b010: return 1'b1;
        3'b001: return 1'b1;
        3'b000: return 1'b0;
        default: return 1'b0;
    endcase
endfunction

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        for (int i = 0; i < 512; i++) begin
            logic left, center, right;
            left = (i == 0)? 1'b0 : current_state[i - 1];
            center = current_state[i];
            right = (i == 511)? 1'b0 : current_state[i + 1];
            next_state[i] <= rule110(left, center, right);
        end
        current_state <= next_state;
    end
end

assign q = current_state;

endmodule