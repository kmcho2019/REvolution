module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // state A = 2'b00, state B = 2'b01, state C = 2'b10, state D = 2'b11
reg [1:0] count; // count the number of clock cycles
reg [1:0] w_count; // count the number of times w = 1
reg [1:0] next_state;
reg next_z;

always @(*) begin
    case(state)
        2'b00: begin // state A
            if(s) begin
                next_state = 2'b01; // move to state B
                next_z = 1'b0;
            end else begin
                next_state = 2'b00; // stay in state A
                next_z = 1'b0;
            end
        end
        2'b01: begin // state B
            if(count == 2'b11) begin // three clock cycles have passed
                next_state = 2'b01; // stay in state B
                if(w_count == 2'b10) begin // w = 1 exactly twice
                    next_z = 1'b1;
                end else begin
                    next_z = 1'b0;
                end
                count = 2'b00; // reset count
                w_count = 2'b00; // reset w_count
            end else begin
                next_state = 2'b01; // stay in state B
                next_z = 1'b0;
                count = count + 1'b1; // increment count
                if(w) begin
                    w_count = w_count + 1'b1; // increment w_count if w = 1
                end
            end
        end
        default: begin
            next_state = 2'b00; // default to state A
            next_z = 1'b0;
        end
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        state <= 2'b00; // reset to state A
        z <= 1'b0;
        count <= 2'b00; // reset count
        w_count <= 2'b00; // reset w_count
    end else begin
        state <= next_state;
        z <= next_z;
    end
end

endmodule