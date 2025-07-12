module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam RUN  = 2'b01;
    localparam DONE = 2'b10;

    reg [1:0] state;
    reg [3:0] i;            // 4-bit counter (0-15)
    reg [15:0] areg;        // Multiplicand register
    reg [31:0] breg_shifted [0:15]; // Pre-shifted multiplier
    reg [31:0] acc;         // Accumulator

    // Pre-compute all possible shifted versions
    integer j;
    always @(*) begin
        for (j = 0; j < 16; j = j + 1) begin
            breg_shifted[j] = bin << j;
        end
    end

    // State machine and counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            i <= 4'd0;
            areg <= 16'd0;
            acc <= 32'd0;
        end
        else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= RUN;
                        areg <= ain;
                        acc <= 32'd0;
                        i <= 4'd0;
                    end
                end
                
                RUN: begin
                    // Accumulate if current bit is set
                    if (areg[i]) begin
                        acc <= acc + breg_shifted[i];
                    end
                    
                    if (i == 4'd15) begin
                        state <= DONE;
                    end
                    else begin
                        i <= i + 4'd1;
                    end
                end
                
                DONE: begin
                    state <= IDLE;
                end
            endcase
        end
    end

    // Output assignments
    assign yout = (state == DONE) ? acc : 32'd0;
    assign done = (state == DONE);

endmodule