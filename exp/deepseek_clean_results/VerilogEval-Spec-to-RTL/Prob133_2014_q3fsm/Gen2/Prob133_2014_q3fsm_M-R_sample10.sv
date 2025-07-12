module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

// State encoding
localparam A = 1'b0;
localparam B = 1'b1;
reg state;

// Counters
reg [1:0] cycle_count;  // 0-2 counter for 3 cycles
reg [1:0] w_count;      // Counts w=1 occurrences

// Output logic
wire next_z;
assign z = next_z;

// State transitions and counters
always @(posedge clk) begin
    if (reset) begin
        state <= A;
        cycle_count <= 2'b0;
        w_count <= 2'b0;
    end else begin
        case (state)
            A: if (s) begin
                state <= B;
                cycle_count <= 2'b0;
                w_count <= 2'b0;
            end
            
            B: begin
                if (cycle_count == 2'b10) begin
                    cycle_count <= 2'b0;
                    w_count <= 2'b0;
                end else begin
                    cycle_count <= cycle_count + 1'b1;
                end
                
                if (w) w_count <= w_count + 1'b1;
            end
        endcase
    end
end

// Combinational output logic
assign next_z = (state == B) && 
                (cycle_count == 2'b10) && 
                (w_count == 2'b10);

endmodule