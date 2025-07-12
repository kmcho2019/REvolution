module TopModule (
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output shift_ena,
    output counting,
    output done
);

// State variable
reg [1:0] state;
reg [1:0] next_state;

// Shift register for start sequence detection
reg [3:0] shift_reg;

// Counter for shifting in duration bits
reg [1:0] shift_count;

// Outputs
assign shift_ena = (state == 2'b01);
assign counting = (state == 2'b10);
assign done = (state == 2'b11);

always @(*) begin
    case (state)
        2'b00: begin // Idle
            if (shift_reg == 4'b1101) begin
                next_state = 2'b01;
                shift_count = 2'b00;
            end else begin
                next_state = 2'b00;
            end
        end
        2'b01: begin // Shift
            if (shift_count == 2'b11) begin
                next_state = 2'b10;
            end else begin
                next_state = 2'b01;
                shift_count = shift_count + 1'b1;
            end
        end
        2'b10: begin // Counting
            if (done_counting) begin
                next_state = 2'b11;
            end else begin
                next_state = 2'b10;
            end
        end
        2'b11: begin // Done
            if (ack) begin
                next_state = 2'b00;
            end else begin
                next_state = 2'b11;
            end
        end
        default: next_state = 2'b00;
    endcase
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= 2'b00;
        shift_reg <= 4'b0000;
        shift_count <= 2'b00;
    end else begin
        state <= next_state;
        shift_reg <= {data, shift_reg[3:1]};
    end
end

endmodule