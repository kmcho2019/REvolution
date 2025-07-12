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
    localparam IDLE = 1'b0;
    localparam RUN  = 1'b1;

    reg state;
    reg [4:0] count;  // 0-16 (5 bits)
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] acc;

    // Next state logic (combinational)
    wire next_state = (state == IDLE) ? (start ? RUN : IDLE) : 
                     (count == 16) ? IDLE : RUN;

    // Shifted version of multiplier (combinational)
    wire [31:0] shifted_b = {16'b0, breg} << count;

    // Accumulate control (combinational)
    wire do_accumulate = (state == RUN) && areg[count];

    // Done flag (combinational)
    assign done = (state == RUN) && (count == 16);

    // Output assignment
    assign yout = acc;

    // Sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 5'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            acc <= 32'd0;
        end
        else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    count <= 5'd0;
                    acc <= 32'd0;
                    if (start) begin
                        areg <= ain;
                        breg <= bin;
                    end
                end

                RUN: begin
                    if (do_accumulate) begin
                        acc <= acc + shifted_b;
                    end
                    count <= count + 1;
                end
            endcase
        end
    end

endmodule