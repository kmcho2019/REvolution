module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

reg [1:0] state; // A = 2'b00, B = 2'b01, B1 = 2'b10, B2 = 2'b11
reg [1:0] count;
reg [1:0] next_state;

always @(*) begin
    case(state)
        2'b00: begin // State A
            if(s == 1'b1) begin
                next_state = 2'b10; // Move to B1
            end else begin
                next_state = 2'b00; // Stay in A
            end
            z = 1'b0;
        end
        2'b10: begin // State B1
            if(w == 1'b1) begin
                count = 2'b01;
            end else begin
                count = 2'b00;
            end
            next_state = 2'b11; // Move to B2
            z = 1'b0;
        end
        2'b11: begin // State B2
            if(w == 1'b1) begin
                count = count + 1'b1;
            end
            next_state = 2'b01; // Move to B3
            z = 1'b0;
        end
        2'b01: begin // State B3
            if(w == 1'b1) begin
                count = count + 1'b1;
            end
            if(count == 2'b10) begin
                z = 1'b1;
            end else begin
                z = 1'b0;
            end
            next_state = 2'b10; // Move back to B1
            count = 2'b00; // Reset counter
        end
        default: begin
            next_state = 2'b00;
            z = 1'b0;
        end
    endcase
end

always @(posedge clk) begin
    if(reset == 1'b1) begin
        state <= 2'b00;
        count <= 2'b00;
    end else begin
        state <= next_state;
    end
end

endmodule