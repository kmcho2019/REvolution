module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    reg [1:0] state;
    localparam IDLE = 2'b00;
    localparam DRIVE = 2'b01;
    localparam SHUTDOWN = 2'b10;
    localparam STOP = 2'b11;

    always @(posedge cpu_overheated or posedge arrived or posedge gas_tank_empty) begin
        case (state)
            IDLE: begin
                if (cpu_overheated) begin
                    state <= SHUTDOWN;
                end else if (!arrived && !gas_tank_empty) begin
                    state <= DRIVE;
                end else if (arrived || gas_tank_empty) begin
                    state <= STOP;
                end
            end
            DRIVE: begin
                if (cpu_overheated) begin
                    state <= SHUTDOWN;
                end else if (arrived || gas_tank_empty) begin
                    state <= STOP;
                end
            end
            SHUTDOWN: begin
                state <= SHUTDOWN;
            end
            STOP: begin
                state <= STOP;
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end

    always @(*) begin
        case (state)
            IDLE: begin
                shut_off_computer <= 0;
                keep_driving <= 0;
            end
            DRIVE: begin
                shut_off_computer <= 0;
                keep_driving <= 1;
            end
            SHUTDOWN: begin
                shut_off_computer <= 1;
                keep_driving <= 0;
            end
            STOP: begin
                shut_off_computer <= 0;
                keep_driving <= 0;
            end
            default: begin
                shut_off_computer <= 0;
                keep_driving <= 0;
            end
        endcase
    end

endmodule