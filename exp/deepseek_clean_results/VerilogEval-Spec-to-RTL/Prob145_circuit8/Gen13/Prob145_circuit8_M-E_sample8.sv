module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] state;
reg a_sync;

// Synchronize input 'a' to clock
always @(posedge clock) begin
    a_sync <= a;
end

// State machine with asynchronous reset
always @(posedge clock or negedge clock) begin
    if (~clock && a) begin
        state <= 2'b00;  // Async reset when clock low and a high
    end
    else if (posedge clock) begin
        case (state)
            2'b00: state <= (p) ? 2'b01 : 2'b00;
            2'b01: state <= 2'b10;
            2'b10: state <= 2'b10;
            default: state <= 2'b00;
        endcase
    end
end

// Output logic
always @(*) begin
    case (state)
        2'b00: begin
            p = a_sync;
            q = 1'b0;
        end
        2'b01: begin
            p = p;
            q = 1'b0;
        end
        2'b10: begin
            p = p;
            q = 1'b1;
        end
        default: begin
            p = 1'b0;
            q = 1'b0;
        end
    endcase
end

initial begin
    state = 2'b00;
    a_sync = 0;
    p = 0;
    q = 0;
end

endmodule