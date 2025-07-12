module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] state;
reg a_sync;

// Synchronize 'a' input to avoid metastability
always @(posedge clock) begin
    a_sync <= a;
end

// State machine and output logic
always @(posedge clock) begin
    case (state)
        2'b00: begin
            if (a_sync) begin
                state <= 2'b01;
                p <= 1'b1;
            end else begin
                p <= 1'b0;
            end
            q <= 1'b0;
        end
        2'b01: begin
            state <= 2'b10;
            p <= a_sync;
            q <= 1'b1;
        end
        2'b10: begin
            if (~a_sync) begin
                state <= 2'b00;
            end
            p <= a_sync;
            q <= p;
        end
        default: begin
            state <= 2'b00;
            p <= 1'b0;
            q <= 1'b0;
        end
    endcase
end

// Reset condition when a=1 during clock low
always @(negedge clock) begin
    if (a) begin
        state <= 2'b00;
        p <= 1'b0;
        q <= 1'b0;
    end
end

endmodule