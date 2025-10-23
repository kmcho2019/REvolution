module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [2:0] state;
reg [2:0] next_state;

always_ff @(posedge clk) begin
    if(reset) begin
        state <= 3'b000; // A
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case(state)
        3'b000: begin // A
            if(w) begin
                next_state = 3'b000; // A
            end else begin
                next_state = 3'b001; // B
            end
        end
        3'b001: begin // B
            if(w) begin
                next_state = 3'b011; // D
            end else begin
                next_state = 3'b010; // C
            end
        end
        3'b010: begin // C
            if(w) begin
                next_state = 3'b011; // D
            end else begin
                next_state = 3'b100; // E
            end
        end
        3'b011: begin // D
            if(w) begin
                next_state = 3'b000; // A
            end else begin
                next_state = 3'b101; // F
            end
        end
        3'b100: begin // E
            if(w) begin
                next_state = 3'b011; // D
            end else begin
                next_state = 3'b100; // E
            end
        end
        3'b101: begin // F
            if(w) begin
                next_state = 3'b011; // D
            end else begin
                next_state = 3'b010; // C
            end
        end
        default: next_state = 3'b000; // A
    endcase
end

assign z = (state == 3'b100) || (state == 3'b101);

endmodule