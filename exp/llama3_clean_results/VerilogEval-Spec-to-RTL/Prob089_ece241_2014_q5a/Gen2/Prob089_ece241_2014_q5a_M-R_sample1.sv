module TopModule(
    input  clk,
    input  areset,
    input  x,
    output reg z
);

reg [1:0] state; // idle, started, error (not used)
reg started;
reg carry;

// state machine
always @ (posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b00; // idle
        started <= 1'b0;
        carry <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // idle
                if(x) begin
                    state <= 2'b01; // started
                    started <= 1'b1;
                    carry <= 1'b0;
                end else begin
                    state <= 2'b00; // idle
                    started <= 1'b0;
                    carry <= 1'b0;
                end
            end
            2'b01: begin // started
                state <= 2'b01; // stay in started state
                if (x) begin
                    carry <= 1'b1;
                end
            end
            default: begin
                state <= 2'b00; // idle
                started <= 1'b0;
                carry <= 1'b0;
            end
        endcase
    end
end

// output logic
always @ (*) begin
    if (state == 2'b00) begin // idle
        z = x;
    end else begin // started
        z = ~(x ^ carry);
    end
end

endmodule