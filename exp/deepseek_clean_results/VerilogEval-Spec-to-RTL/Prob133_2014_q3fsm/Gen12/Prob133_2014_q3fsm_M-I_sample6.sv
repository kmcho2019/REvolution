module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // State encoding
    reg state;
    localparam A = 1'b0;
    localparam B = 1'b1;

    // Window tracking (one-hot encoded cycle count)
    reg [2:0] cycle;  // One-hot: cycle[0]=1st, cycle[1]=2nd, cycle[2]=3rd
    reg [1:0] w_buf;   // Stores w values from previous 2 cycles
    wire [1:0] ones_count = w_buf[0] + w_buf[1] + w;

    // Enable signals
    wire counting_en = (state == B) && (cycle != 3'b100);
    wire buf_update_en = (state == B) && (cycle != 3'b001);

    // Next state logic
    wire next_state = (state == A) ? (s ? B : A) : B;

    // Output logic
    assign z = (state == B) && (cycle == 3'b100) && (ones_count == 2'd2);

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            cycle <= 3'b001;
            w_buf <= 2'b00;
        end else begin
            state <= next_state;
            
            if (state == B) begin
                // Update cycle counter (rotating one-hot)
                cycle <= {cycle[1:0], cycle[2]};
                
                // Update w buffer only when needed
                if (buf_update_en) begin
                    w_buf <= {w_buf[0], w};
                end
            end else begin
                // Reset counters in state A
                cycle <= 3'b001;
                w_buf <= 2'b00;
            end
        end
    end

endmodule