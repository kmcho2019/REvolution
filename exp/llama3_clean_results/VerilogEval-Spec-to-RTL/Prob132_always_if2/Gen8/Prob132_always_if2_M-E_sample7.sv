enum logic [0:0] { Normal, Emergency } state;

module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    always @(*) begin
        case (state)
            Normal: begin
                shut_off_computer = 0;
                keep_driving = ~arrived && ~gas_tank_empty;
                if (cpu_overheated) begin
                    state = Emergency;
                end
            end
            Emergency: begin
                shut_off_computer = 1;
                keep_driving = 0;
                if (~cpu_overheated) begin
                    state = Normal;
                end
            end
        endcase
    end

    initial begin
        state = Normal;
    end

endmodule