module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    // State definitions
    localparam IDLE = 1'b0;
    localparam BUSY = 1'b1;

    reg state;
    reg [4:0] count;
    reg [15:0] areg;
    reg [31:0] acc;
    reg [15:0] breg;

    // Barrel shifter implementation
    wire [31:0] shifted_bin = bin << count;

    // Output assignments
    assign yout = acc;
    assign done = (state == BUSY) && (count == 5'd16);

    // Counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 5'b0;
        end else begin
            if (state == BUSY) begin
                count <= count + 1;
            end else begin
                count <= 5'b0;
            end
        end
    end

    // Main FSM
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            areg <= 16'b0;
            breg <= 16'b0;
            acc <= 32'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= BUSY;
                        areg <= ain;
                        breg <= bin;
                        acc <= 32'b0;
                    end
                end
                
                BUSY: begin
                    if (count < 16) begin
                        if (areg[count]) begin
                            acc <= acc + shifted_bin;
                        end
                    end else begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule